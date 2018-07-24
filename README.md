# DataWorks

DataWorks makes it easier to work with FactoryGirl in the context of a complex
data model.

DataWorks has these benefits:

* Reduces test data bloat.
* Improves test clarity.
* Improves test correctness.
* Reduces refactoring cost when changing the data model.
* Improves test performance.


## Contents

* [The Problem That DataWorks Solves](#the-problem-that-dataworks-solves)
* [How DataWorks Solves This Problem](#how-dataworks-solves-this-problem)
    * [Approach](#approach)
    * [Implementation](#implementation)
    * [Benefits](#benefits)
* [Usage](#usage)
    * [Basic Example](#basic-example)
    * [Referencing Objects](#referencing-objects)
    * [Adding Multiple Objects](#adding-multiple-objects)
    * [Avoiding Object Reuse](#avoiding-object-reuse)
    * [Overriding Attributes](#overriding-attributes)
    * [Better Variable Names](#better-variable-names)
    * [Visualizing the Object Graph](#visualizing-the-object-graph)
    * [Setup and Configuration](#setup-and-configuration)
        * [Configuration](#configuration)
        * [Subclassing DataWorks::Base](#subclassing-dataworksbase)
* [Issues](#issues)



## The Problem That DataWorks Solves

Consider the following data model:


                ,----------,
                |          |
          .----(1) County (1)----.
          |     |          |     |
          |     '----------'     |
          |                      |
          |                      |
     ,---(*)----,           ,---(*)----,
     |          |           |          |
     |  Person (*)---------(1) School  |
     |          |           |          |
     '----------'           '----------'


* A Person must live in a County.
* A Person can optionally attend a School.
* A School must belong to a County.

Let's say we need to test the method School#number_of_people.  So we factory
two people and a school and add the people to the school.  Then we test
that number_of_people returns two.  The problem is that our object graph
would look like this:


      ,----------,      ,----------,      ,----------,
      |          |      |          |      |          |
      |  County  |      |  County  |      |  County  |
      |          |      |          |      |          |
      '----.-----'      '----.-----'      '----.-----'
           |                 |                 |
           |                 |                 |
      ,----'-----,      ,----'-----,      ,----'-----,
      |          |      |          |      |          |
      |  Person  |      |  Person  |------|  School  |
      |          |      |          |      |          |
      '----.-----'      '----------'      '----.-----'
           |                                   |
           `-----------------------------------'


Each Person object and the School object would have their own individual
county because the factories don't know that they should all be the same
county.  Now this probably won't affect the accuracy of a simple method
like number_of_people, but in the case of more complex business logic,
having an incorrect object graph could cause the test to fail even though
the code under test is correct.  So we need to make sure our factory
objects reflect a valid state of the system.

The takeaway is that we need to manually factory a County object and pass
it to the Person and School factories to ensure that only one County object
exists.

Now consider a more complex data model:


                  ,-----------,
                  |           |
                  |   Region  |
                  |           |
                  '----(1)----'
                        |
                        |
                        |
                  ,----(*)----,
                  |           |
            .----(1)  State  (1)----.
            |     |           |     |
            |     '-----------'     |
            |                       |
            |                       |
      ,----(*)---,            ,----(*)---,        ,------------------,
      |          |            |          |        |                  |
      |   Town   |      .----(1) County (1)------(1) SchoolDistrict  |
      |          |      |     |          |        |                  |
      '----(1)---'      |     '-----.----'        '-------(1)--------'
            |           |                                  |
            |    ,------'                                  |
            |    |                                         |
      ,----(*)--(*)                                   ,---(*)----,
      |          |                                    |          |
      |  Person (*)----------------------------------(1) School  |
      |          |                                    |          |
      '----------'                                    '----------'


* A Person must live in a County.
* A Person must live in a Town.
* Towns can span Counties.
* A Town must be in a State.
* A County must be in a State.
* A State must be in a Region.
* A County has one and only one SchoolDistrict.
* A SchoolDistrict has many Schools.
* A Person can optionally attend a School.

Let's say we need to test the method School#number_of_people.  So we factory
a couple of Person models and a School model.  But if that's all we did,
we'll have a proliferation of separate parent models, such as three separate
County objects, five separate State objects, and five separate Region
objects.

In order to craft accurate test data, we're forced to manage this manually.
We need to factory all the parent objects and pass them down to their
child factories.  So even though we are mostly caring about how a School
model interacts with a Person model, we are forced to factory five different
parent models.



## How DataWorks Solves This Problem

### Approach

DataWorks solves this problem by following one simple rule:  **by default, reuse
objects that already exist.**

When using FactoryGirl, a factory only concerns itself with its particular
neighborhood of the data model.  Since FactoryGirl factories do not know
the big picture, their default is not to reuse existing objects but create
new ones.  This results in the proliferation of unwanted objects.

DataWorks knows the big picture of your data model and assumes that you are
wanting to build a consistently connected network of models.  So it will
reuse objects that already exist unless explicitly told otherwise.

### Implementation

DataWorks exists as a layer on top of FactoryGirl.  DataWorks assumes that
you have FactoryGirl factories for each model and that they create valid
objects.  DataWorks always uses a create strategy with FactoryGirl.

### Benefits

Here's how DataWorks gives us the following benefits:

* **Reduces test data bloat.**  The amount of test data code that you have
  to write is significantly reduced.
* **Improves test clarity.**  DataWorks allows you to factory only the
  objects that are relevant to what's being tested.  Having to factory
  up a bunch of indirectly-related objects distracts from what the test
  is trying to communicate.
* **Improves test correctness.**  Manually preventing the duplication of
  parent factories is more error-prone than having DataWorks do it
  automatically.
* **Reduces refactoring cost when changing the data model.**  If you refactor
  the data model high up in the parent chain, you aren't forced to touch
  practically every test that has factoried test data, since DataWorks allows
  for implied, not explicit, parents.
* **Improves test performance.**  Because intermediate models aren't being
  created, there is a small performance benefit.



## Usage

### Basic Example

```ruby
describe "School#number_of_people" do
  before do
    data = TheDataWorks.new
    @school = data.add_school
    data.add_person(school: @school)
    data.add_person(school: @school)
  end

  it "returns the correct number of people attending that school" do
    expect( @school.number_of_people ).to eq( 2 )
  end
end
```

* Always start by creating a new DataWorks object.  This starts DataWorks off
  with a blank slate of objects.
* Use add_[model_name] to create a new object.
* The necessary parent objects (SchoolDistrict, Town, County, etc.) are implied.

### Referencing Objects

* Any object that's created through DataWorks can be referenced by calling
  [model_name][number] to DataWorks.
* Objects are numbered in the order they are created.
* the_[model_name] is a synonym for [model_name]1 that can aid test readability.

Here's a test that puts two people in one school and three in another:

```ruby
describe "School#number_of_people" do
  before do
    data = TheDataWorks.new
    data.add_school
    data.add_school
    data.add_person(school: data.school1)
    data.add_person(school: data.school1)
    data.add_person(school: data.school2)
    data.add_person(school: data.school2)
    data.add_person(school: data.school2)
    @school = data.school1
  end

  it "returns the correct number of people attending that school" do
    expect( @school.number_of_people ).to eq( 2 )
  end
end
```

If we wanted to check the number of people in the school district, we can
access the SchoolDistrict created behind the scenes like this:

```ruby
data.school_district1.number_of_people
```

Or we could use the synonym:

```ruby
data.the_school_district.number_of_people
```

### Adding Multiple Objects

You can factory many objects at once by passing an integer count as the first argument to `add_`

DataWorks treats any call to `add_` with an integer as the first argument as an attempt to create
multiple objects. For clarity and readability DataWorks allows you to use the plural name of the
models being created. This is not required

Given

```ruby
data = TheDataWorks.new
data.add_schools(10)
```

and

    data.add_school(10)

Will both create 10 school records.

Plural model names are converted to singular using the `ActiveSupport` inflections module. If you
need to specify any additional inflection rules you can add them in your test configuration. For
reference here is the example given in the Rails documentation.

```ruby
ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.plural /^(ox)$/i, '\1\2en'
  inflect.singular /^(ox)en/i, '\1'

  inflect.irregular 'octopus', 'octopi'

  inflect.uncountable 'equipment'
end
```

### Avoiding Object Reuse

Let's say that we want to factory two Schools and want to avoid having them
automatically share a SchoolDistrict.  We can do this by simply manually
creating separate SchoolDistrict objects and explicitly setting them when
we create the Schools:

```ruby
data = TheDataWorks.new
data.add_school_districts(2)
data.add_school(school_district: data.school_district1)
data.add_school(school_district: data.school_district2)
```

The case above works find for records which only need to be different in one
association but what if we want to generate a chain of associations or need to
create many record which all need to share certain associations?

Given the data model described above say that we want to be able to create two
schools but have them each belong to a different state with the two states
belonging to the same region. DataWorks can restrict the possible 'parentage' of
models using the `#set_restriction` method.

```ruby
massachusetts = data.add_state(name: 'Massachusetts')
vermont       = data.add_state(name: 'Vermont')

# We now have two states so lets create those schools...

mass_school = data.add_school # this will cause a SchoolDistrict and County to be created

data.set_restriction(for_model: :state, to: vermont)

vermont_school = data.add_school # this will also cause a SchoolDistrict and County to be created
```

The return value of `#set_restriction` is the parent object passed as `to:`.

Had we not used the `set_restriction` method above we would have needed to set
the vermont model hierarchy up manually like so.

```ruby
vermont_county   = data.add_county
vermont_district = data.add_school_district(county: vermont_county)
vermont_school   = data.add_school(school_district: vermont_district)
```

The `#set_restriction` method also accepts a block. When the block form is used
the restriction applies only to those records added within the block.

The return value of the block form of `#set_restriction` is the last statement
evaluated in the block.

DataWorks also provides a `#set_current_default` method which allows you to set
the current default record to use when automatically associating models.

Say we want to create multiple towns which belong to two states. We can do so
like this

```ruby
massachusetts = data.add_state(name: 'Massachusetts')
vermont       = data.add_state(name: 'Vermont')

data.add_towns(3) # this will create 3 towns all belonging to massachusetts

# massachusetts was the default above since it was created first. Now we
# want vermont to be the default state for 3 more towns

data.set_current_default(to: vermont, for_model: :state)

data.add_towns(3) # this will create 3 towns all belonging to vermont
```

Both `set_current_default` and `set_restriction` have corresponding `clear_X_for`
methods for removing the default/restricting record.

### Overriding Attributes

DataWorks simply delegates to the factory corresponding to the model, so
it will use the default attributes specified there.  If you pass attributes
to DataWorks, it will pass them on to the factory:

```ruby
data = TheDataWorks.new
data.add_school_district(name: 'Washington', rural: true)
```

### Better Variable Names

Let's say you don't like calling your test data by number and want more
meaningful names.  Just use plain old Ruby variables to make your tests
clearer:

```ruby
data = TheDataWorks.new
franklin = data.add_school_district(name: 'Franklin')
greenville = data.add_school_district(name: 'Greenville')
data.add_school(school_district: franklin)
data.add_school(school_district: greenville)
```

### Visualizing the Object Graph

If you want to debug your test data and explicitly see the object graph that
DataWorks created for you, you can use the visualize method which will render
an object graph for you and automatically open it:

```ruby
data = TheDataWorks.new
data.add_school_district
data.add_school
data.visualize
```

If an object labeled "unmanaged" appears in the object graph it means that
an object was factoried outside of DataWorks.  This can happen if your
base factories create children (not parent) associations by default.  Note
that the object graph cannot show the entire set of all objects that
were created, just those created through DataWorks and some of the associated
objects that may have been created outside of DataWorks and attached to
a DataWorks-managed factory object.

### Setup and Configuration

DataWorks expects the following:

* You must have factories for all of your models, and these factories must
  produce valid (persistable) models.
* None of these basic factories should create any child objects by default,
  as this does not give DataWorks a chance to manage them.
* You must configure DataWorks in your spec_helper.rb by calling
  DataWorks.configure.  This is where you teach DataWorks about your
  data model relationships.
* You must have a class that subclasses DataWorks::Base.  Use this in your
  tests; do not use DataWorks::Base directly.
* You must tell DataWorks if you have any associations with special names (the `belongs_to` or `has_many` do not match the model names).  You can do this by passing in a hash instead of a symbol for the parent model name: `{ :association_name => :model_name }`

#### Configuration

##### Necessary Parents

In your spec_helper.rb file, put the following:

```ruby
DataWorks.configure do |config|
  config.necessary_parents = {
    classroom:             [:school, :grade],
    district:              [ ],
    event:                 [:schedule, :school],
    failure:               [:service_schedule_set],
    grade:                 [ ],
    iep_service:           [:service, :student],
    schedule:              [:service_schedule_set],
    scheduled_service:     [{:schedulable => :event}, :student, :iep_service],
    school:                [:district],
    service:               [:district, :service_type],
    service_schedule_set:  [:district, :service],
    service_type:          [ ],
    student:               [:school, :classroom],
  }
end
```

`config.necessary_parents` is where you tell DataWorks which other factories
must be created when you create a particular factory.  Because FactoryGirl
causes a proliferation of extra objects, DataWorks does not allow FactoryGirl
to create necessary associated objects.  Instead, DataWorks will create the
necessary parent objects and pass them down into the factory, ensuring that
too many parent objects do not get created.

This must list all of the models.

You must keep this list up to date when you change your data model.  To aid
with this, whenever a belongs_to relationship changes in your code,
DataWorks raises an error that reminds you that you need to update this
configuration to match the new data model.

##### Polymorphic Parents

The `:scheduled_services` portion of the configuration above demonstrates DataWorks' support for polymorphic associations. Rather than a symbol for the necessary parent a polymorphic class must have a hash, of a single key/value pair, which names the polymorphic relationship and indicates which possible parent should be created by default. Note that other possible parent objects can be passed as arguments when the child object is being created as with any other classes.

##### Autocreated Children

DataWorks can handle models that autocreate a child object:

```ruby
DataWorks.configure do |config|
  config.necessary_parents = {
    ...
  }

  config.autocreated_children = {
    city: [:city_location]
  }
end
```

For example, let's say that every time a `City` model is created, it must have a `CityLocation` model, so there is logic in the `City` model that autocreates a `CityLocation` object.  Note that when a model does this, DataWorks has no way of knowing about this autocreated child object and so it is not managed by DataWorks and could end up being a zombie object that could break your tests.  So by explicitly listing out the names of the models that get autocreated, this gives DataWorks a chance to remove the zombie object and hook up a DataWorks-aware object in its place.

Note that this is only for the situation where a model autocreates a single child model, not multiple.

##### Blessing

Once you're satisfied the configuration is accurate, run

```sh
$ rake data_works:bless
```

And DataWorks will no longer complain (until you the next time you change a
belongs_to relationship).

#### Subclassing DataWorks::Base

Subclass DataWorks::Base and call it whatever you want, such as TheDataWorks.
spec/support is a good place to put this.

Inside of this class you can put some convenience functions.  For example,
if you find yourself frequently factorying two types of objects together,
you can add a convenience function here.



## Issues

* DataWorks does not yet work with namespaced models.
* DataWorks does not support factory traits
* DataWorks does not allow associations where the foreign key name is not the same as the class name
* The visualization component uses respond_to in verifying associations, which is not the most robust method if has_many is missing or with :through associations.

# Credit

DataWorks was developed by [Wyatt Greene](https://github.com/techiferous) and [Luke Inglis](https://github.com/ludamillion) at [The District Management Group](https://github.com/dmcouncil). 
