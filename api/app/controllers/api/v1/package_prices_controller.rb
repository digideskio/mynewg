class Api::V1::PackagePricesController < Api::ApplicationController

  def purchase
    respond_with_interaction PurchasePackagePriceInteraction
  end
end
