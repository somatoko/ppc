defmodule Ppc.Plan.Money do
  @derive Jason.Encoder
  defstruct [:currency_code, :value]

  @type t :: %__MODULE__{
          currency_code: String.t(),
          value: String.t()
        }

  @spec new(String.t(), String.t()) :: __MODULE__.t()
  def new(currency, value) do
    %__MODULE__{
      currency_code: currency,
      value: value
    }
  end
end
