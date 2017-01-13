module Jrails
  module JrailsHelper
    # This function can be used to render rjs inline
    #
    # <%= javascript_function do |page|
    #   page.replace_html :list, :partial => 'list', :object => @list
    # end %>
    #
    def javascript_function(*args, &block)
      html_options = args.extract_options!
      function = args[0] || ''

      html_options.symbolize_keys!
      function = update_page(&block) if block_given?
      javascript_tag(function)
    end

    def jquery_id(id)
      id.to_s.count('#.*,>+~:[/ ') == 0 ? "##{id}" : id
    end

    def jquery_ids(ids)
      Array(ids).map { |id| jquery_id(id) }.join(',')
    end

    USE_PROTECTION = const_defined?(:DISABLE_JQUERY_FORGERY_PROTECTION) ? !DISABLE_JQUERY_FORGERY_PROTECTION : true

    unless const_defined? :JQUERY_VAR
      JQUERY_VAR = 'jQuery'
    end

    unless const_defined? :JQCALLBACKS
      JQCALLBACKS = Set.new([:beforeSend, :complete, :error, :success] + (100..599).to_a)
      #instance_eval { remove_const :AJAX_OPTIONS }
      remove_const(:AJAX_OPTIONS) if const_defined?(:AJAX_OPTIONS)
      AJAX_OPTIONS = Set.new([:before, :after, :condition, :url,
                              :asynchronous, :method, :insertion, :position,
                              :form, :with, :update, :script]).merge(JQCALLBACKS)
    end

    def periodically_call_remote(options = {})
      frequency = options[:frequency] || 10 # every ten seconds by default
      code = "setInterval(function() {#{remote_function(options)}}, #{frequency} * 1000)"
      javascript_tag(code)
    end

    def remote_function(options)
      javascript_options = options_for_ajax(options)

      update = ''
      if options[:update] && options[:update].is_a?(Hash)
        update = []
        update << "success:'#{options[:update][:success]}'" if options[:update][:success]
        update << "failure:'#{options[:update][:failure]}'" if options[:update][:failure]
        update = '{' + update.join(',') + '}'
      elsif options[:update]
        update << "'#{options[:update]}'"
      end

      function = "#{JQUERY_VAR}.ajax(#{javascript_options})"

      function = "#{options[:before]}; #{function}" if options[:before]
      function = "#{function}; #{options[:after]}" if options[:after]
      function = "if (#{options[:condition]}) { #{function}; }" if options[:condition]
      function = "if (confirm('#{escape_javascript(options[:confirm])}')) { #{function}; }" if options[:confirm]
      return function
    end
  end
end