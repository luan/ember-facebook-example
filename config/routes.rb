EmberFacebook::Application.routes.draw do
  root to: "home#index"
  match "*path" => "home#index"
end
