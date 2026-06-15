module Contentstack
  class Region
    EU       = 'eu'
    US       = 'us'       # alias for the 'na' region in regions.json
    AZURE_NA = 'azure-na'
    AZURE_EU = 'azure-eu'
    GCP_NA   = 'gcp-na'
    GCP_EU   = 'gcp-eu'
    AU       = 'au'
  end

  class Service
    # Full camelCase keys matching regions.json
    CONTENT_DELIVERY   = 'contentDelivery'
    CONTENT_MANAGEMENT = 'contentManagement'
    PREVIEW            = 'preview'
    AUTH               = 'auth'
    GRAPHQL_DELIVERY   = 'graphqlDelivery'
    GRAPHQL_PREVIEW    = 'graphqlPreview'
    IMAGES             = 'images'
    ASSETS             = 'assets'
    AUTOMATE           = 'automate'
    LAUNCH             = 'launch'
    DEVELOPER_HUB      = 'developerHub'
    BRAND_KIT          = 'brandKit'
    GEN_AI             = 'genAI'
    PERSONALIZE_MGMT   = 'personalizeManagement'
    PERSONALIZE_EDGE   = 'personalizeEdge'
    COMPOSABLE_STUDIO  = 'composableStudio'
    ASSET_MANAGEMENT   = 'assetManagement'
    APPLICATION        = 'application'

    # Short aliases kept for backward compatibility
    CDA = CONTENT_DELIVERY
    CMA = CONTENT_MANAGEMENT
  end

  class Host
    PROTOCOL     = 'https://'
    DEFAULT_HOST = 'cdn.contentstack.io'
    HOST         = 'contentstack.com'
  end
end
