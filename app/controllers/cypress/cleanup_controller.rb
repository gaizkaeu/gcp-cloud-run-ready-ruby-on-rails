module Cypress
  class CleanupController < ActionController::Base
    def destroy
      return unless Rails.configuration.x.cypress

      tables = ActiveRecord::Base.connection.tables
      tables.delete 'schema_migrations'
      tables.each do |t|
        ActiveRecord::Base.connection.execute("TRUNCATE #{t} CASCADE")
      end

      head :ok
    end
  end
end
