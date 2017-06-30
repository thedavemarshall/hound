require "rails_helper"

RSpec.describe "Subscriptions" do
  it "deletes a subscription" do 
    subscription = create(:subscription, :active)
    another_subscription = create(
      :subscription,
      :active,
      stripe_subscription_id: subscription.stripe_subscription_id,
    )
    params = {
      "type": "customer.subscription.deleted",
      "object": "event",
      "pending_webhooks": 1,
      "data": {
        "object": {
          "id": subscription.stripe_subscription_id,
          "object": "subscription",
          "customer": "cus_00000000000000",
          "quantity": 1,
          "status": "canceled",
        }
      }
    }
    
    post "/deleted_subscriptions", params: params

    subscription.reload
    another_subscription.reload
    expect(subscription).to be_deleted
    expect(another_subscription).to be_deleted
    expect(subscription.repo).not_to be_active
    expect(another_subscription.repo).not_to be_active
  end
end
