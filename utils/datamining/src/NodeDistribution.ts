type Node = { X: number; Y: number; Z: number };

export class NodeDistributionCalculator {
    nodes: Node[] = [];

    mean(): Node {
        const totalNodes = this.nodes.length;
        if (totalNodes === 0) {
            throw new Error("No nodes available to calculate mean.");
        }

        const sum = this.nodes.reduce(
            (acc, node) => ({
                X: acc.X + node.X,
                Y: acc.Y + node.Y,
                Z: acc.Z + node.Z,
            }),
            { X: 0, Y: 0, Z: 0 }
        );

        return {
            X: sum.X / totalNodes,
            Y: sum.Y / totalNodes,
            Z: sum.Z / totalNodes,
        };
    }

    center(): Node {
        if (this.nodes.length === 0) {
            throw new Error("No nodes available to calculate center.");
        }

        const min = this.nodes.reduce(
            (acc, node) => ({
                X: Math.min(acc.X, node.X),
                Y: Math.min(acc.Y, node.Y),
                Z: Math.min(acc.Z, node.Z),
            }),
            { X: Infinity, Y: Infinity, Z: Infinity }
        );

        const max = this.nodes.reduce(
            (acc, node) => ({
                X: Math.max(acc.X, node.X),
                Y: Math.max(acc.Y, node.Y),
                Z: Math.max(acc.Z, node.Z),
            }),
            { X: -Infinity, Y: -Infinity, Z: -Infinity }
        );

        return {
            X: (min.X + max.X) / 2,
            Y: (min.Y + max.Y) / 2,
            Z: (min.Z + max.Z) / 2,
        };
    }

    covarianceMatrix(): number[][] {
        const totalNodes = this.nodes.length;
        if (totalNodes === 0) {
            throw new Error(
                "No nodes available to calculate covariance matrix."
            );
        }

        const mean = this.mean();

        const covariance = [
            [0, 0],
            [0, 0],
        ];

        for (const node of this.nodes) {
            const diffX = node.X - mean.X;
            const diffZ = node.Z - mean.Z;

            covariance[0][0] += diffX * diffX;
            covariance[0][1] += diffX * diffZ;

            covariance[1][0] += diffZ * diffX;
            covariance[1][1] += diffZ * diffZ;
        }

        for (let i = 0; i < 2; i++) {
            for (let j = 0; j < 2; j++) {
                covariance[i][j] /= totalNodes;
            }
        }

        return covariance;
    }

    eigenvalues2x2(matrix: number[][]): number[] {
        if (
            matrix.length !== 2 ||
            matrix[0].length !== 2 ||
            matrix[1].length !== 2
        ) {
            throw new Error("Input must be a 2x2 matrix.");
        }

        const a = matrix[0][0];
        const b = matrix[0][1];
        const c = matrix[1][0];
        const d = matrix[1][1];

        const trace = a + d;
        const determinant = a * d - b * c;

        const discriminant = Math.sqrt(trace * trace - 4 * determinant);

        const eigenvalue1 = (trace + discriminant) / 2;
        const eigenvalue2 = (trace - discriminant) / 2;

        return [eigenvalue1, eigenvalue2];
    }

    distance3D(node1: Node, node2: Node): number {
        const dx = node1.X - node2.X;
        const dy = node1.Y - node2.Y;
        const dz = node1.Z - node2.Z;

        return Math.sqrt(dx * dx + dy * dy + dz * dz);
    }

    groupIntoClusters(threshold = 66) {
        const clusters = [];

        for (const point of this.nodes) {
            let added = false;
            for (const cluster of clusters) {
                for (const member of cluster) {
                    if (this.distance3D(point, member) <= threshold) {
                        cluster.push(point);
                        added = true;
                        break;
                    }
                }
                if (added) break;
            }
            if (!added) {
                clusters.push([point]);
            }
        }

        return clusters;
    }

    roundTo(n: number, decimals: number) {
        return Math.round(n * 10 ** decimals) / 10 ** decimals;
    }

    averagePoint(nodes: Node[]): Node {
        const totalNodes = nodes.length;
        if (totalNodes === 0) {
            throw new Error("No nodes available to calculate average point.");
        }

        const sum = nodes.reduce(
            (acc, node) => ({
                X: acc.X + node.X,
                Y: acc.Y + node.Y,
                Z: acc.Z + node.Z,
            }),
            { X: 0, Y: 0, Z: 0 }
        );

        return {
            X: sum.X / totalNodes,
            Y: sum.Y / totalNodes,
            Z: sum.Z / totalNodes,
        };
    }

    isChainlike(threshold = 0.9) {
        if (this.nodes.length < 2) return false;

        const meanVec = this.mean();
        const centered = this.center();
        const cov = this.covarianceMatrix();
        const [λ1, λ2] = this.eigenvalues2x2(cov);

        const explained = λ1 / (λ1 + λ2);
        return explained >= threshold;
    }
}
