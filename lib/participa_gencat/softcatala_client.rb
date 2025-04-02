# frozen_string_literal: true

module ParticipaGencat
  class SoftcatalaClient
    LOCALE_MAPPING= {
      ca: "cat",
      en: "en",
      es: "spa",
      oc: "oc_aran"
    }

    def translate(text, source_locale, target_locale)
      response= request_translation(text, source_locale, target_locale)

      translated_text= JSON.parse(response.body).dig("responseData", "translatedText")
      Rails.logger.info %(SC TRANSLATED: [#{source_locale}] "#{text}" => [#{target_locale}] "#{translated_text}")
      translated_text
    end

    #---------------------------------------------------
    private

    #---------------------------------------------------

    def request_translation(text, source_locale, target_locale)
      locale_from= map_locale(source_locale)
      locale_to= map_locale(target_locale)

      form_fields= {}
      form_fields[:langpair]= "#{locale_from}|#{locale_to}"
      form_fields[:q]= text
      form_fields[:markUnknown]= "y"

      url = URI("https://www.softcatala.org/api/traductor/translate")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.set_debug_output($stdout) if Rails.env.development?

      @request = Net::HTTP::Post.new(url)
      @request["Content-Type"]= "application/x-www-form-urlencoded; charset=UTF-8"
      @request["User-Agent"]= "ParticipaGencat.cat"
      @request["Accept"]= "application/json, text/javascript, */*; q=0.01"
      @request["Accept-Language"]= "ca,en-US;q=0.7,en;q=0.3"
      @request["Pragma"]= "no-cache"
      @request["Cache-Control"]= "no-cache"

      form_fields_urlencoded = form_fields.map { |pname, pvalue| "#{pname}=#{CGI.escape(pvalue)}" }.join("&")
      @request.body= form_fields_urlencoded

      response = http.request(@request)

      Rails.logger.debug { "SoftCatala RS code: #{response.code} #{response.msg}" }
      Rails.logger.debug { "SoftCatala RS body: #{response.body}" }

      response
    end

    def map_locale(locale)
      # <!-- .btns-llengues-desti  -->
      # <div class="btns-llengues-desti btn-group" role="group">
      #   <button type="button" class="btn bt select" id="target-spa">castellà</button>
      #   <button type="button" class="btn bt" id="target-cat">català</button>
      #   <div class="btn-group" role="group">
      #     <!-- dropdown llengues -->
      #     <div id="div_select_target">
      #     <select class="form-control selectpicker bt" id="target-select">
      #       <option value="en">anglès</option>
      #       <option value="deu">alemany</option>
      #       <option value="oc_aran">occità/aranès</option>
      #       <option value="oci">occità/llenguadoc</option>
      #       <option value="ron">romanès</option>
      #       <option value="fr">francès</option>
      #       <option value="pt">portuguès</option>
      #       <option value="arg">aragonès</option>
      #       <option value="nld">neerlandès</option>
      #       <option value="ita">italià</option>
      #       <option value="jpn">japonès</option>
      #       <option value="glg">gallec</option>
      #       <option value="eus">basc</option>
      #     </select>
      #     </div><!--/dropdown llengues -->
      LOCALE_MAPPING[locale.to_sym]
    end
  end
end
