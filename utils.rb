module WatirUtils

    def login
        un = @b.text_field :id => 'username'
        un.set 'khuntley'
        pw = @b.text_field :id => 'password'
        pw.set 'password'
        login_button = @b.button :id => 'login'
        login_button.click
    end

    def click_nav_link(group, item)
        group_link = @b.link :text => group
        group_link.when_present.click

        doc_link = @b.link :text => item
        doc_link.when_present.click
    end

    def set_document_description(description)
        doc_description = @b.text_field :id => 'document.documentHeader.documentDescription'
        doc_description.when_present.set description
    end

    def validate_text_field(field_id, value=nil)
        field = @b.text_field :id => field_id
        if value.nil?
            assert(field.value.empty?)
        else
            assert_equal(value, field.value)
        end
    end

    def validate_accounting_line(group, sequence, vals)
        acct_line_selector = 'document.' + group + 'AccountingLine[' + sequence + ']'
        if (vals.has_key? :chart)
            source_account_chart = @b.select :id => acct_line_selector + '.chartOfAccountsCode'
            assert_equal(1, source_account_chart.when_present.selected_options.size)
            assert_equal(vals[:chart], source_account_chart.selected_options[0].value)
        else
            source_account_chart = @b.select :id => acct_line_selector + '.chartOfAccountsCode'
            assert_equal(0, source_account_chart.when_present.selected_options.size)
        end

        validate_text_field(acct_line_selector + '.accountNumber', vals[:accountNumber])
        validate_text_field(acct_line_selector + '.subAccountNumber', vals[:subAccountNumber])
        validate_text_field(acct_line_selector + '.financialObjectCode', vals[:financialObjectCode])
        validate_text_field(acct_line_selector + '.financialSubObjectCode', vals[:financialSubObjectCode])
        validate_text_field(acct_line_selector + '.projectCode', vals[:projectCode])
        validate_text_field(acct_line_selector + '.organizationReferenceId', vals[:organizationReferenceId])
        validate_text_field(acct_line_selector + '.amount', vals[:amount])
        validate_text_field(acct_line_selector + '.financialDocumentLineDescription', vals[:financialDocumentLineDescription])
    end
end