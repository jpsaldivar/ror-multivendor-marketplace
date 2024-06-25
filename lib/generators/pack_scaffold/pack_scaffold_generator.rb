# lib/generators/pack_scaffold/pack_scaffold_generator.rb
require 'rails/generators'
require 'rails/generators/rails/scaffold/scaffold_generator'

class PackScaffoldGenerator < Rails::Generators::ScaffoldGenerator
  source_root Rails::Generators::ScaffoldGenerator.source_root

  argument :attributes, type: :array, default: [], banner: "field:type field:type"

  def create_scaffold_files
    pack_name = ask("Enter the pack name:").underscore
    @pack_path = "packs/#{pack_name}"

    generate_model
    generate_controller
    generate_views
    generate_migration
    generate_routes
  end

  private

  def generate_model
    template "model.rb", File.join(@pack_path, "app/models", "#{file_name}.rb")
  end

  def generate_controller
    template "controller.rb", File.join(@pack_path, "app/controllers", controller_class_path, "#{controller_file_name}_controller.rb")
  end

  def generate_views
    %w[index show new edit _form].each do |view|
      template "views/#{view}.html.erb", File.join(@pack_path, "app/views", controller_file_path, "#{view}.html.erb")
    end
  end

  def generate_migration
    migration_template "migration.rb", File.join("db/migrate", "create_#{table_name}.rb")
  end

  def generate_routes
    route "resources :#{file_name.pluralize}"
  end
end
