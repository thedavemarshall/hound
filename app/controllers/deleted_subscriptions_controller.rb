class DeletedSubscriptionsController < ApplicationController
  skip_before_action :authenticate, only: :create

  def create
    if params.dig("type") == "customer.subscription.deleted"
      subscription_id = params.dig("data", "object", "id")
      Subscription.where(stripe_subscription_id: subscription_id).destroy_all.each do |subscription|
        subscription.repo.deactivate
      end
    end
  end
end
