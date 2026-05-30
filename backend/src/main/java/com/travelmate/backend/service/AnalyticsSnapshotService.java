package com.travelmate.backend.service;

import com.travelmate.backend.dto.AnalyticsSnapshotDTO;
import java.util.List;

public interface AnalyticsSnapshotService {
    AnalyticsSnapshotDTO create(AnalyticsSnapshotDTO dto);

    AnalyticsSnapshotDTO update(AnalyticsSnapshotDTO dto);

    AnalyticsSnapshotDTO findById(Long id);

    List<AnalyticsSnapshotDTO> listAll();

    void delete(Long id);
}
