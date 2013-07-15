let g:rails_projections = {
      \   "config/projections.json": {
      \     "command": "projections"
      \   },
      \   "config/routes.rb": {
      \     "command": "routes"
      \   },
      \   "spec/features/*_spec.rb": {
      \     "command": "feature",
      \     "template": "require 'spec_helper'\n\ndescribe '%h' do\n\nend",
      \     "keywords": "describe context before it feature scenario"
      \   },
      \   "app/presenters/*.rb": {
      \     "command": "presenter",
      \     "template": "class %S\n\nend",
      \     "test": "spec/presenters/%i_spec.rb"
      \   }
      \ }

let g:rails_gem_projections = {
      \   "active_model_serializers": {
      \     "app/serializers/*_serializer.rb": {
      \       "command": "serializer",
      \       "affinity": "model"
      \     }
      \   },
      \   "simple_form": {
      \     "app/inputs/*_input.rb": {
      \       "command": "input",
      \       "template": "class %SInput < SimpleForm::Inputs::CHANGEME\n  def input\n\n  end\nend"
      \     }
      \   },
      \   "factory_girl_rails": {
      \     "spec/factories/*_factory.rb": {
      \       "command": "factory",
      \       "affinity": "collection",
      \       "alternate": "app/models/%i.rb",
      \       "related": "db/schema.rb#%s",
      \       "test": "spec/models/%i_spec.rb",
      \       "template": "FactoryGirl.define do\n  factory :%i do\n  end\nend",
      \       "keywords": "factory sequence"
      \     }
      \   }
      \ }
