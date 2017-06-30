class DeletedSubscriptionsController < ApplicationController
  skip_before_action :authenticate, only: :create

  def create
    subscription_id = params.dig("data", "object", "id")
    Subscription.where(stripe_subscription_id: subscription_id).destroy_all.each do |sub|
      sub.repo.deactivate
    end
  end
end
