defmodule Ppc.Testing.SubscriptionTes do
  def details_not_found(_id, _opts) do
    {:error, "Requested resource ID was not found."}
  end

  def details_non_conforming_id(_id, _opts) do
    {:error, %{"description" => "The value of a field does not conform to the expected format."}}
  end

  def details_ok(_id, _opts) do
    {:ok,
     %{
       "billing_info" => %{
         "cycle_executions" => [
           %{
             "current_pricing_scheme_version" => 1,
             "cycles_completed" => 93,
             "cycles_remaining" => 0,
             "sequence" => 1,
             "tenure_type" => "REGULAR",
             "total_cycles" => 0
           }
         ],
         "failed_payments_count" => 0,
         "last_payment" => %{
           "amount" => %{"currency_code" => "EUR", "value" => "2.0"},
           "time" => "2022-03-26T12:00:32Z"
         },
         "next_billing_time" => "2022-03-29T10:00:00Z",
         "outstanding_balance" => %{"currency_code" => "EUR", "value" => "0.0"}
       },
       "create_time" => "2021-06-23T13:00:13Z",
       "id" => "I-KKKKKKKKKKKK",
       "links" => [
         %{
           "href" =>
             "https://api.sandbox.paypal.com/v1/billing/subscriptions/I-KKKKKKKKKKKK/cancel",
           "method" => "POST",
           "rel" => "cancel"
         },
         %{
           "href" => "https://api.sandbox.paypal.com/v1/billing/subscriptions/I-KKKKKKKKKKKK",
           "method" => "PATCH",
           "rel" => "edit"
         },
         %{
           "href" => "https://api.sandbox.paypal.com/v1/billing/subscriptions/I-KKKKKKKKKKKK",
           "method" => "GET",
           "rel" => "self"
         },
         %{
           "href" =>
             "https://api.sandbox.paypal.com/v1/billing/subscriptions/I-KKKKKKKKKKKK/suspend",
           "method" => "POST",
           "rel" => "suspend"
         },
         %{
           "href" =>
             "https://api.sandbox.paypal.com/v1/billing/subscriptions/I-KKKKKKKKKKKK/capture",
           "method" => "POST",
           "rel" => "capture"
         }
       ],
       "plan_id" => "P-000000000000000000000000",
       "plan_overridden" => false,
       "quantity" => "1",
       "shipping_amount" => %{"currency_code" => "EUR", "value" => "0.0"},
       "start_time" => "2021-06-23T12:58:46Z",
       "status" => "ACTIVE",
       "status_update_time" => "2022-03-26T12:00:33Z",
       "subscriber" => %{
         "email_address" => "email@example.com",
         "name" => %{"given_name" => "Daniel", "surname" => "O'Connor"},
         "payer_id" => "KKKKKKKKKKKKK"
       },
       "update_time" => "2022-03-26T12:00:33Z"
     }}
  end
end
