#monkeypatch: fix error in tracker
#it will fixed in future versions: https://github.com/redmine/redmine/commit/df8bbb56f1c7950bc4197c3ce92ba7548d2937f7

module RedmineReminder
  module TrackerPatch
    def self.included(base)
      base.extend ClassMethods
      base.class_eval do
        class << self
          alias_method_chain :all, :args
        end
      end
    end

    module ClassMethods
      def all_with_args(*args)
        args ? find(:all, *args) : all_without_args
      end
    end
  end
end
