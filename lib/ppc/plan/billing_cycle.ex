defmodule Ppc.Plan.BillingCycle do
  alias Ppc.Plan.PricingScheme

  defstruct [:pricing_scheme, :frequency, :tenure_type, :sequence, :total_cycles]

  @type tenure_type :: :regular | :trial

  @type t :: %__MODULE__{
          pricing_scheme: PricingScheme.t(),
          frequency: String.t(),
          tenure_type: tenure_type(),
          sequence: integer,
          total_cycles: integer
        }

  @doc """
  Notes

  - sequence: order position with other cycles in the list. Starts with 1. Cycles are executed
    with each increasing number.
  - total_cycles: the number of times this billing cycle gets executed.
    - for `:trial` can only be between 1 and 999.
    - for `:regular` can be between 0 and 999, where 0 means infinite number of times.
  """
  @spec new(PricingScheme.t(), String.t(), tenure_type(), integer, integer) :: __MODULE__.t()
  def new(schema, freq, type, seq, cycles \\ 1) do
    %__MODULE__{
      pricing_scheme: schema,
      frequency: freq,
      tenure_type: type,
      sequence: seq,
      total_cycles: cycles
    }
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(value, opts) do
      {_, value} =
        Map.drop(value, [:__struct__])
        |> Map.get_and_update(:tenure_type, fn v ->
          {v, Atom.to_string(v) |> String.upcase()}
        end)

      Jason.Encode.map(value, opts)
    end
  end
end
