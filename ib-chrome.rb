require 'watir'
require 'test/unit'


class FirstWatirTestDontJudgeUs < Test::Unit::TestCase

  def test_ib()
b = Watir::Browser.new :firefox
b.goto 'https://monsters-stg.kuali.co/fin'

# log in as khuntley
un = b.text_field :id => 'username'
un.set 'khuntley'
pw = b.text_field :id => 'password'
pw.set 'password'
login_button = b.button :id => 'login'
login_button.click

# init an ib
group_link = b.link :text => 'Accounting'
group_link.when_present.click

doc_link = b.link :text => 'Internal Billing'
doc_link.when_present.click

# start filling in fields
doc_description = b.text_field :id => 'document.documentHeader.documentDescription'
doc_description.when_present.set 'KFSPRJQ-1326'

import_source_button = b.link :id => 'document.sourceAccountingLinesShowLink'
import_source_button.click
import_source_al_file = b.file_field :name => 'sourceFile'
import_source_al_file.when_present.set '/Users/james/java/projects/watir-test/FINTR14_IB_Import.csv'

import_source_al_button = b.button :name => 'methodToCall.uploadSourceLines.document.sourceAccountingLines'
import_source_al_button.click

#validate data
source_account_chart = b.select :id => 'document.sourceAccountingLine[0].chartOfAccountsCode'
assert_equal(1, source_account_chart.when_present.selected_options.size)
assert_equal('BL', source_account_chart.selected_options[0].value)

source_account_account = b.text_field :id => 'document.sourceAccountingLine[0].accountNumber'
assert_equal('1031400', source_account_account.value)

source_account_sub_account = b.text_field :id => 'document.sourceAccountingLine[0].subAccountNumber'
assert(source_account_sub_account.value.empty?)

source_account_object = b.text_field :id => 'document.sourceAccountingLine[0].financialObjectCode'
assert_equal('5000', source_account_object.value)

source_account_sub_object = b.text_field :id => 'document.sourceAccountingLine[0].financialSubObjectCode'
assert(source_account_sub_object.value.empty?)

source_account_project = b.text_field :id => 'document.sourceAccountingLine[0].projectCode'
assert(source_account_project.value.empty?)

source_account_org_ref = b.text_field :id => 'document.sourceAccountingLine[0].organizationReferenceId'
assert(source_account_org_ref.value.empty?)

source_account_amount = b.text_field :id => 'document.sourceAccountingLine[0].amount'
assert_equal('100,000.00', source_account_amount.value)

source_account_line_description = b.text_field :id => 'document.sourceAccountingLine[0].financialDocumentLineDescription'
assert(source_account_line_description.value.empty?)

b.close
end
end
