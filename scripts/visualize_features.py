from os import remove
import torch
from sklearn.manifold import TSNE
import time
from matplotlib import pyplot as plt
import seaborn as sns
import numpy as np


def removeOutliers(x, outlierConstant):
    a = np.array(x)
    upper_quartile = np.percentile(a, 75)
    lower_quartile = np.percentile(a, 25)
    IQR = (upper_quartile - lower_quartile) * outlierConstant
    quartileSet = (lower_quartile - IQR, upper_quartile + IQR)

    return np.where((a >= quartileSet[0]) & (a <= quartileSet[1]))


if __name__ == '__main__':

    datafile = 'knn_data_metric_learning.pth'
    data = torch.load(datafile)
    time_start = time.time()
    tsne = TSNE(n_components=2, verbose=1, perplexity=40, n_iter=300)
    print(data['x'].shape, len(data['y']))
    tsne_results = tsne.fit_transform(data['x'].squeeze())
    print('t-SNE done! Time elapsed: {} seconds'.format(time.time()-time_start))
    inl_inds_0 = removeOutliers(tsne_results[:, 0], 1.5)[0]
    inl_inds_1 = removeOutliers(tsne_results[:, 1], 1.5)[0]
    print(inl_inds_0.shape)
    print(len(set(list(inl_inds_0) + list(inl_inds_1))))
    indices = set(inl_inds_0).union(set(inl_inds_1))
    tsne_results = tsne_results[list(indices), :]

    labels = [data['y'][i] for i in list(indices)]

    fig = plt.figure(figsize=(16, 10))

    print(tsne_results.shape, len(data['y']))
    sns.scatterplot(
        x=tsne_results[:, 0], y=tsne_results[:, 1],
        hue=data['y'],
        palette=sns.color_palette("hls", len(set(data['y']))),
        # data=df_subset,
        legend="full",
        # alpha=0.3
    )
    plt.show()
    plt.savefig(f'vis_results_{datafile.split(".")[0]}.png')
