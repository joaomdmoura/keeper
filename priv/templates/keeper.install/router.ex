scope "/", <%= app_module %> do
    resources "/<%= plural_resource_name %>", <%= resource_name %>Controller, only: [:create]