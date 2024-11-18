require 'logger'

require_relative 'services/supplier_service'
require_relative 'models/hotel'
require_relative 'suppliers/acme_supplier'
require_relative 'suppliers/patagonia_supplier'
require_relative 'suppliers/paperflies_supplier'

logger = Logger.new(STDOUT)

if ARGV.length != 2
  logger.error "Usage: ruby #{__FILE__} <hotel_ids> <destination_ids>"
  exit(1)
end

hotel_ids_strings, destination_id_strings = ARGV
hotel_ids = hotel_ids_strings == 'none' ? [] : hotel_ids_strings.split(',')
destination_ids = destination_id_strings == 'none' ? [] : destination_id_strings.split(',')

SUPPLIER_CLASSES = [AcmeSupplier, PatagoniaSupplier, PaperfliesSupplier]

begin
  supplier_service = SupplierService.new(SUPPLIER_CLASSES)

  logger.info("Fetching and merging data from suppliers")
  merged_data = supplier_service.fetch_and_merge

  logger.info("Creating hotel objects")
  hotels = merged_data.map { |hotel_data| Hotel.new(hotel_data) }

  logger.info("Finished creating #{hotels.size} hotel objects")

  logger.info("Filtering hotels")
  filtered_hotels = Hotel.filter(hotels, hotel_ids: hotel_ids, destination_ids: destination_ids)

  logger.info "Filtered Hotels:\n#{filtered_hotels}"

rescue => e
  logger.error("An error occurred: #{e.message}\n#{e.backtrace.join("\n")}")
  exit(1)
end
