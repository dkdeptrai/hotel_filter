require 'logger'

require_relative 'services/supplier_service'
require_relative 'models/hotel'
require_relative 'suppliers/acme_supplier'
require_relative 'suppliers/patagonia_supplier'
require_relative 'suppliers/paperflies_supplier'

if ARGV.length != 2
  Logger.new(STDOUT).error "Usage: ruby #{__FILE__} <hotel_ids> <destination_ids>"
  exit(1)
end

hotel_ids_strings, destination_id_strings = ARGV
hotel_ids = hotel_ids_strings == 'none' ? [] : hotel_ids_strings.split(',')
destination_ids = destination_id_strings == 'none' ? [] : destination_id_strings.split(',')

SUPPLIER_CLASSES = [AcmeSupplier, PatagoniaSupplier, PaperfliesSupplier]

begin
  supplier_service = SupplierService.new(SUPPLIER_CLASSES)

  Logger.new(STDOUT).info("Fetching and merging data from suppliers")
  merged_data = supplier_service.fetch_and_merge

  Logger.new(STDOUT).info("Creating hotel objects")
  hotels = merged_data.map { |hotel_data| Hotel.new(hotel_data) }

  Logger.new(STDOUT).info("Finished creating #{hotels.size} hotel objects")

  Logger.new(STDOUT).info("Filtering hotels")
  filtered_hotels = Hotel.filter(hotels, hotel_ids: hotel_ids, destination_ids: destination_ids)

  puts "Filtered Hotels:\n#{filtered_hotels}"

rescue => e
  Logger.new(STDOUT).error("An error occurred: #{e.message}")
  exit(1)
end
