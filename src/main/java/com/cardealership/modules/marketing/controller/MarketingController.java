package com.cardealership.modules.marketing.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cardealership.common.dto.Result;
import com.cardealership.modules.marketing.entity.*;
import com.cardealership.modules.marketing.service.MarketingService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/marketing")
@RequiredArgsConstructor
public class MarketingController {
    private final MarketingService marketingService;

    @GetMapping("/campaigns")
    public Result<Page<MktCampaign>> campaigns(@RequestParam(defaultValue = "1") int page,
                                                @RequestParam(defaultValue = "10") int size) {
        return Result.success(marketingService.pageCampaigns(page, size));
    }

    @PostMapping("/campaigns")
    public Result<?> saveCampaign(@RequestBody MktCampaign c) { marketingService.saveCampaign(c); return Result.success(); }

    @PutMapping("/campaigns/{id}")
    public Result<?> updateCampaign(@PathVariable Long id, @RequestBody MktCampaign c) { c.setId(id); marketingService.saveCampaign(c); return Result.success(); }

    @DeleteMapping("/campaigns/{id}")
    public Result<?> deleteCampaign(@PathVariable Long id) { marketingService.deleteCampaign(id); return Result.success(); }

    @GetMapping("/coupons")
    public Result<Page<MktCoupon>> coupons(@RequestParam(defaultValue = "1") int page,
                                            @RequestParam(defaultValue = "10") int size) {
        return Result.success(marketingService.pageCoupons(page, size));
    }

    @PostMapping("/coupons")
    public Result<?> saveCoupon(@RequestBody MktCoupon c) { marketingService.saveCoupon(c); return Result.success(); }

    @PutMapping("/coupons/{id}")
    public Result<?> updateCoupon(@PathVariable Long id, @RequestBody MktCoupon c) { c.setId(id); marketingService.saveCoupon(c); return Result.success(); }

    @DeleteMapping("/coupons/{id}")
    public Result<?> deleteCoupon(@PathVariable Long id) { marketingService.deleteCoupon(id); return Result.success(); }
}
