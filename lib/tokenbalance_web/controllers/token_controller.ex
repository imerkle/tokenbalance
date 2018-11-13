defmodule TokenbalanceWeb.TokenController do
  	use TokenbalanceWeb, :controller

    def balance(conn, %{"address" => address,"tokens" => tokens}) do
        t0 = Task.async(fn ->
            balances = %{}
            Enum.map(tokens, 
            fn x ->
                balances = Map.put(balances, x, getBalance(address, x))
            end)
        end)
        x = Task.await(t0)
        json(conn, x)
      end
    
    def getBalance(address, token_address ) do 
        {:ok, address} = address |> String.slice(2..-1) |> Base.decode16(case: :mixed)
        contract_address = token_address
        abi_encoded_data = ABI.encode("balanceOf(address)", [address]) |> Base.encode16(case: :lower)
        
        
        {:ok, balance_bytes} = Ethereumex.HttpClient.eth_call(%{
            data: "0x" <> abi_encoded_data,
            to: contract_address
            })

        balance = balance_bytes |> String.slice(2..-1) |> Base.decode16!(case: :lower) |> ABI.TypeDecoder.decode_raw([{:uint, 256}]) |> List.first       
        balance
    end

end