defmodule Ppc.Subscription.PayerName do
  defstruct [
    :given_name,
    :surname
  ]

  @type t :: %__MODULE__{
          given_name: String.t(),
          surname: String.t()
        }
end
