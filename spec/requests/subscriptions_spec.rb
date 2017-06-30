require "rails_helper"

RSpec.describe "Subscriptions" do
  context "when event is for subscription deleted" do
    it "deletes all subscription records and deactivates their repos" do 
      subscription = create(:subscription, :active)
      another_subscription = create(
        :subscription,
        :active,
        stripe_subscription_id: subscription.stripe_subscription_id,
      )
      params = {
        "type": "customer.subscription.deleted",
        "object": "event",
        "data": {
          "object": {
            "id": subscription.stripe_subscription_id,
            "object": "subscription",
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

  context "when event is not subscription deleted" do
    it "does not delete subscription" do
      subscription = create(:subscription, :active)
      params = {
        "type": "customer.subscription.updated",
        "data": {
          "object": {
            "id": subscription.stripe_subscription_id,
            "object": "subscription",
          }
        }
      }

      post "/deleted_subscriptions", params: params

      subscription.reload
      expect(subscription).not_to be_deleted
      expect(subscription.repo).to be_active
    end
  end
end
