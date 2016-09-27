require 'rubygems'
require 'watir'
require 'test/unit'
require './utils'


class FirstWatirTestDontJudgeUs < Test::Unit::TestCase
  include WatirUtils

  def setup
    @b = Watir::Browser.new :chrome
  end

  def teardown
    @b.close
  end

  def test_ib
    @b.goto 'https://monsters-stg.kuali.co/fin'

    # log in as khuntley
    login

    # init an ib
    click_nav_link('Accounting', 'Internal Billing')

    # start filling in fields
    set_document_description('KFSPRJQ-1326')

    import_source_button = @b.link :id => 'document.sourceAccountingLinesShowLink'
    import_source_button.click
    import_source_al_file = @b.file_field :name => 'sourceFile'
    import_source_al_file.when_present.set Dir.pwd + '/FINTR14_IB_Import.csv'

    import_source_al_button = @b.button :name => 'methodToCall.uploadSourceLines.document.sourceAccountingLines'
    import_source_al_button.click

    #validate data
    vals = {:chart => 'BL', :accountNumber => '1031400', :financialObjectCode => '5000', :amount => '100,000.00'}
    validate_accounting_line('source', '0', vals)
  end
end
