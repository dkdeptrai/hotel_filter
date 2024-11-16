require_relative 'suppliers/supplier'
require_relative 'suppliers/acme_supplier'
require_relative 'suppliers/paperflies_supplier'
require_relative 'suppliers/patagonia_supplier'
test = PaperfliesSupplier.new
test.fetch_data
