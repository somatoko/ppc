defmodule Ppc.Plan.Taxes do
  @derive Jason.Encoder
  defstruct [:percentage, :inclusive]

  @type t :: %__MODULE__{
          percentage: String.t(),
          inclusive: boolean
        }

  @doc """
  Parameters:

  - percent - the tax percentage on the billing amount. Whole integers or with fractions, positive or
    negative. E.g. `10`, `20.025`.
  - inclusive - if true will mean that the tax is already included in the billing amount.
  """
  @spec new(String.t(), boolean) :: __MODULE__.t()
  def new(percent, inclusive) do
    %__MODULE__{
      percentage: percent,
      inclusive: inclusive
    }
  end
end
