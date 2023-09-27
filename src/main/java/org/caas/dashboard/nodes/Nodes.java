package org.caas.dashboard.nodes;

import lombok.Data;
import org.caas.dashboard.common.model.CommonMetaData;
import org.caas.dashboard.common.model.CommonSpec;
import org.caas.dashboard.nodes.support.NodesStatus;

/**
 * Nodes Model 클래스
 *
 * @author Hyungu Cho
 * @version 1.0
 * @since 2018.08.13
 */
@Data
public class Nodes {
    private String resultCode;
    private String resultMessage;

    private CommonMetaData metadata;
    private CommonSpec spec;
    private NodesStatus status;

    private String nodeName;
}
