defmodule Ppc.Plan.PricingTier do
  alias Ppc.Plan.Money

  defstruct [:starting_quantity, :ending_quantity, :amount]

  @type t :: %__MODULE__{
          starting_quantity: String.t(),
          ending_quantity: String.t(),
          amount: Money.t()
        }

  @doc """
  Create a pricing tier for a plan.


  """
  @spec new(String.t(), String.t(), Money.t()) :: __MODULE__.t()
  def new(starting, ending, amount) do
    %__MODULE__{
      starting_quantity: starting,
      ending_quantity: ending,
      amount: amount
    }
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(value, opts) do
      {_, value} =
        Map.drop(value, [:__struct__])
        |> Map.get_and_update(:ending_quantity, fn v ->
          if is_nil(v) || v == "", do: :pop, else: {v, v}
        end)

      Jason.Encode.map(value, opts)
    end
  end
end
