package com.travelmate.backend.repository;

import com.travelmate.backend.entity.OAuthAccount;
import com.travelmate.backend.entity.enums.OAuthProvider;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface OAuthAccountRepository extends JpaRepository<OAuthAccount, Long> {
    Optional<OAuthAccount> findByProviderAndProviderUserId(OAuthProvider provider, String providerUserId);

    Optional<OAuthAccount> findByUserIdAndProvider(Long userId, OAuthProvider provider);
}
