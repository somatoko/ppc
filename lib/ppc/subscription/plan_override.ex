defmodule Ppc.Subscription.PlanOverride do
  alias Ppc.Plan.{BillingCycle, PaymentPreferences, Taxes}

  defstruct [
    :billing_cycles,
    :payment_preferences,
    :taxes
  ]

  @type t :: %__MODULE__{
          billing_cycles: [BillingCycle.t()],
          payment_preferences: PaymentPreferences.t(),
          taxes: Taxes.t()
        }
end
