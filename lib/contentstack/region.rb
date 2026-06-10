module Contentstack
  class Region
    EU       = 'eu'
    US       = 'us'
    AZURE_NA = 'azure-na'
    AZURE_EU = 'azure-eu'
    GCP_NA   = 'gcp-na'
    GCP_EU   = 'gcp-eu'
  end

  class Service
    CDA     = 'cda'
    CMA     = 'cma'
    PREVIEW = 'preview'
  end

  class Host
    PROTOCOL     = 'https://'
    DEFAULT_HOST = 'cdn.contentstack.io'
    HOST         = 'contentstack.com'
  end
end
