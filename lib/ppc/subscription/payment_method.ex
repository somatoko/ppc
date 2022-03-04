defmodule Ppc.Subscription.PaymentMethod do
  alias Ppc.Subscription.PlanOverride

  defstruct [
    :payer_selected,
    :payee_preferred,
    :standard_entry_class_code
  ]

  @type payee_preferred :: :unrestricted | :immediate_payment_required

  @type t :: %__MODULE__{
          payer_selected: String.t(),
          payee_preferred: payee_preferred,
          standard_entry_class_code: String.t()
        }
end
