require 'spec_helper'

describe NetSuite::Records::InvoiceItem do
  let(:item) { NetSuite::Records::InvoiceItem.new }

  it 'has the right fields' do
    [
      :amount, :amount_ordered, :bin_numbers, :cost_estimate, :cost_estimate_type, :current_percent, :defer_rev_rec,
      :description, :gift_cert_from, :gift_cert_message, :gift_cert_number, :gift_cert_recipient_email,
      :gift_cert_recipient_name, :gross_amt, :inventory_detail, :is_taxable, :item_is_fulfilled, :license_code, :line, :klass,
      :options, :order_line, :percent_complete, :quantity, :quantity_available, :quantity_fulfilled, :quantity_on_hand,
      :quantity_ordered, :quantity_remaining, :rate, :rev_rec_end_date, :rev_rec_start_date, :serial_numbers, :ship_group,
      :tax1_amt, :tax_rate1, :tax_rate2, :vsoe_allocation, :vsoe_amount, :vsoe_deferral, :vsoe_delivered, :vsoe_permit_discount,
      :vsoe_price
    ].each do |field|
      item.should have_field(field)
    end
  end

  it 'has the right record_refs' do
    [
      :department, :item, :job, :location, :price, :rev_rec_schedule, :ship_address, :ship_method, :tax_code, :units
    ].each do |record_ref|
      item.should have_record_ref(record_ref)
    end
  end

  it 'can initialize from a record' do
    record = NetSuite::Records::InvoiceItem.new(:amount => 123, :cost_estimate => 234)
    item   = NetSuite::Records::InvoiceItem.new(record)
    item.should be_kind_of(NetSuite::Records::InvoiceItem)
    item.amount.should eql(123)
    item.cost_estimate.should eql(234)
  end

  describe '#custom_field_list' do
    it 'can be set from attributes' do
      attributes = {
        :custom_field => {
          :value => 10,
          :internal_id => 'custfield_value'
        }
      }
      item.custom_field_list = attributes
      item.custom_field_list.should be_kind_of(NetSuite::Records::CustomFieldList)
      item.custom_field_list.custom_fields.length.should eql(1)
      item.custom_field_list.custfield_value.attributes[:value].should eq(10)
    end

    it 'can be set from a CustomFieldList object' do
      custom_field_list = NetSuite::Records::CustomFieldList.new
      item.custom_field_list = custom_field_list
      item.custom_field_list.should eql(custom_field_list)
    end
  end

  describe '#to_record' do
    before do
      item.amount      = '7'
      item.description = 'Some thingy'
    end

    it 'can represent itself as a SOAP record' do
      record = {
        'tranSales:amount'      => '7',
        'tranSales:description' => 'Some thingy'
      }
      item.to_record.should eql(record)
    end
  end

  describe '#record_type' do
    it 'returns a string of the SOAP record type' do
      item.record_type.should eql('tranSales:InvoiceItem')
    end
  end

end
