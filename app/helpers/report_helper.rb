module ReportHelper
  def coupon_options(coupon_id)
    options_for_select Coupon.all.map{ |coupon| [coupon.name, coupon.id]}, coupon_id
  end
end
