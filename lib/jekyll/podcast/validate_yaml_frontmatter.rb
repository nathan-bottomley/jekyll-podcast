# frozen_string_literal: true

require 'date'
require 'yaml'
require 'json'
require 'json-schema'

module Jekyll
  module Podcast
    # Validate the frontmatter of each document using schemas in the _schemas directory
    module ValidateYAMLFrontmatter
      class << self
        date_proc = lambda { |value|
          begin
            Date.iso8601(value)
          rescue ArgumentError
            raise JSON::Schema::CustomFormatError, 'must be in ISO-8601 format: CCYY-MM-DD'
          end
        }
        JSON::Validator.register_format_validator('full-date', date_proc)

        def print_validation_complete_message(error_count)
          if error_count.zero?
            Jekyll.logger.info 'YAML frontmatter validated successfully'.yellow
          else
            Jekyll.logger.info "YAML frontmatter validation failed with #{error_count} errors".yellow
          end
        end

        def print_document_validation_failed_message(document, errors)
          Jekyll.logger.info "Validation failed for #{document.path}:".yellow
          Jekyll.logger.info(errors.map { |x| "- #{x}" }.join("\n").yellow)
        end

        def validate_document(document)
          return [] unless File.exist? "_schemas/#{document.collection.label}.json"

          document_frontmatter = YAML.safe_load_file(document.path, permitted_classes: [Date]).to_json
          JSON::Validator.fully_validate("_schemas/#{document.collection.label}.json", document_frontmatter)
        end

        def validate_site(site)
          Jekyll.logger.info 'Validating YAML frontmatter'.yellow
          error_count = 0
          site.documents.each do |document|
            result = validate_document(document)
            next if result.empty?

            error_count += result.length
            print_document_validation_failed_message(document, result)
          end
          print_validation_complete_message(error_count)
        end
      end
    end
  end
end

Jekyll::Hooks.register :site, :pre_render do |site, _payload|
  Jekyll::Podcast::ValidateYAMLFrontmatter.validate_site(site)
end