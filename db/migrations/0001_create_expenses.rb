Sequel.migration do
  change do
    create_table :expenses do
      primary_key :id
      String :vendor
      Float :amount
      Date :date
    end
  end
end
