require_relative './base_report'

module SocMed
  module Services
    module Reports
      class Create < BaseReport

        def call(&block)
          reported_object = create_reported_object

          yield(Success.new(reported_object), NoTrigger)
        rescue ActiveRecord::RecordNotFound, SocMed::Reports::AlreadyExistsError, StandardError => e
          yield(NoTrigger, Failure.new(e))
        end

        private

        def create_reported_object
          reported_object = owner.reportable_objects.build(target: target)

          return reported_object if reported_object.save!
        end

      end
    end
  end
end