module Notification
  def flash_to_cookie
    [:notice, :warn, :error].each do |key|
      if (_flash_ = flash[key]).present?
        if _flash_.is_a?(String)
          _flash_ = {text: _flash_}
        end
        cookies["flash.#{key}"] = _flash_.to_json
        flash.discard(key)
      end
    end
  end
end
