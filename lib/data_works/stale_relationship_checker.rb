module DataWorks
  class StaleRelationshipChecker
    class << self

      def check!
        if snapshot_exists?
          check_for_staleness!
        else
          create_snapshot!
        end
      end

      def create_snapshot!
        File.open(filepath, 'w') do |f|
          f.puts explanatory_comments
          f.puts "DataWorks::MOST_RECENT_SNAPSHOT = ["
          current_snapshot.each do |class_name, belongs_to_name|
            f.puts "  ['#{class_name}', #{belongs_to_name}],"
          end
          f.puts "]"
        end
      end

    private

      def check_for_staleness!
        load_snapshot
        saved = DataWorks::MOST_RECENT_SNAPSHOT
        current = current_snapshot
        if saved != current
          differences = (saved - current) + (current - saved)
          message = "DataWorks has detected changes to your data model. "
          message << "DataWorks requires that the config.necessary_parents "
          message << "in your spec_helper.rb file be an accurate description "
          message << "of what parent objects need to be automatically "
          message << "factoried. Please update this configuration to be "
          message << "accurate, if necessary.  Then run rake data_works:bless "
          message << "to tell DataWorks that the configuration is now "
          message << "up-to-date."
          message << "\nHere's a hint as to where the data model changes "
          message << "are #{differences.inspect}."
          raise ModelRelationshipsOutOfDateError.new(message)
        end
      end

      def snapshot_exists?
        File.exists?(filepath)
      end

      def explanatory_comments
        <<-COMMENTS.strip_heredoc
          # THIS IS A GENERATED FILE.  DO NOT EDIT.
          #
          # Generated on #{Time.now.inspect}.
          #
          # This file is used by DataWorks to check whether data model
          # changes have occurred.  When you change the data model, you
          # need to update DataWorks' configuration.  See the DataWorks
          # README for details.
          #
        COMMENTS
      end

      def current_snapshot
        all_active_record_classes.map do |ar_class|
          [ar_class.name, ar_class.reflect_on_all_associations(:belongs_to).map(&:name)]
        end.sort_by(&:first)
      end

      def load_snapshot
        load filepath
      end

      def filepath
        File.join(Rails.root, 'db', 'data_works_relationship_snapshot.rb')
      end

      def all_active_record_classes
        @all_classes ||= begin
          Rails.application.eager_load!
          ActiveRecord::Base.send(:descendants)
        end
      end

    end
  end
end
