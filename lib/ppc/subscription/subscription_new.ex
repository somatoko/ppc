defmodule Ppc.Subscription.SubscriptionNew do
  alias Ppc.Plan.{Money}
  alias Ppc.Subscription.{ApplicationContext, PlanOverride, SubscriberRequest}

  defstruct [
    :plan_id,
    :start_time,
    :quantity,
    :shipping_amount,
    :subscriber,
    :auto_renewal,
    :application_context,
    :custom_id,
    :plan
  ]

  @type t :: %__MODULE__{
          plan_id: String.t(),
          start_time: String.t(),
          quantity: String.t(),
          shipping_amount: Money.t(),
          subscriber: SubscriberRequest.t(),
          auto_renewal: boolean,
          application_context: ApplicationContext.t(),
          custom_id: String.t(),
          plan: PlanOverride.t()
        }
end
