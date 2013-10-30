module Grape
end
require 'kaminari'
Kaminari::Hooks.init
require 'kaminari/models/active_record_extension'
::ActiveRecord::Base.send :include, Kaminari::ActiveRecordExtension

