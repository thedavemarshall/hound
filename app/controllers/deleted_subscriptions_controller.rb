class DeletedSubscriptionsController < ApplicationController
  skip_before_action :authenticate, only: :create

  def create
    DeleteSubscriptions.call(params)
  end
end
