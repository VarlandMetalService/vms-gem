module VMS

  #
  class PrinterChooser

    def self.choose

      return nil if request.nil?
      return nil if request.remote_ip.nil?

      return request.remote_ip

    end

  end

end