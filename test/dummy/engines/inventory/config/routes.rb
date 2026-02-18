# frozen_string_literal: true

Inventory::Engine.routes.draw do
  root to: "dashboard#index"

  resources :items
end
