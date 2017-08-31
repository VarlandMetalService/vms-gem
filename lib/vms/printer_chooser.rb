module VMS

  #
  class PrinterChooser

    OFFICE_XEROX_ADDRESSES = ["192.168.82.50",
                              "192.168.82.51",
                              "192.168.82.52",
                              "192.168.82.53",
                              "192.168.82.54",
                              "192.168.82.55",
                              "192.168.82.56",
                              "192.168.82.57",
                              "192.168.82.58",
                              "192.168.82.59",
                              "192.168.82.60",
                              "192.168.82.61",
                              "192.168.82.62",
                              "192.168.82.63"]
    OFFICE_XEROX_CODE = :ox
    PRODUCTION_DELL_ADDRESSES = ["192.168.82.64",
                                 "192.168.82.65",
                                 "192.168.82.66"]
    PRODUCTION_DELL_CODE = :ph
    DEFAULT_PRINTER_CODE = :lp

    def self.choose(ip=nil)

      case ip
      when *self.class::OFFICE_XEROX_ADDRESSES
        return self.class::OFFICE_XEROX_CODE
      when *self.class::PRODUCTION_DELL_ADDRESSES
        return self.class::PRODUCTION_DELL_CODE
      else
        return self.class::DEFAULT_PRINTER_CODE
      end

    end

  end

end