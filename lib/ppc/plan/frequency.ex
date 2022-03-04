defmodule Ppc.Plan.Frequency do
  defstruct [:interval_unit, :interval_count]

  @type interval_unit :: :day | :week | :month | :year

  @type t :: %__MODULE__{
          interval_unit: interval_unit(),
          interval_count: integer
        }

  @doc """
  Create a pricing tier for a plan.

  - interval_unit: unit to which `interval_count` is applied.
  - interval_count: the number of intervals after which a subscriber is billed. Alloved value depends
  on the chosen `interval_unit`. Example: `unit=:day, count=3` will bill every three days.


  """
  @spec new(interval_unit, integer) :: __MODULE__.t()
  def new(unit, count) do
    %__MODULE__{
      interval_unit: unit,
      interval_count: count
    }
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(value, opts) do
      {_, value} =
        Map.drop(value, [:__struct__])
        |> Map.get_and_update(:interval_unit, fn v ->
          {v, Atom.to_string(v) |> String.upcase()}
        end)

      Jason.Encode.map(value, opts)
    end
  end
end
