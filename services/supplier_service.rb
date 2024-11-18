require_relative '../suppliers/supplier'
require_relative '../suppliers/acme_supplier'
require_relative '../suppliers/patagonia_supplier'
require_relative '../suppliers/paperflies_supplier'

require_relative 'hotel_data_merger'
class SupplierService
  def initialize(supplier_classes)
    @supplier_classes = supplier_classes
  end

  def fetch_all_data
    @data = @supplier_classes.map do |supplier_class|
      Logger.new(STDOUT).info "Working on #{supplier_class}"
      supplier_class.new.fetch_data
    end
  end

  def merge_data
    @merged_data = HotelDataMerger.merge(@data)
  end

  def fetch_and_merge
    fetch_all_data
    merge_data
    @merged_data
  end
end

