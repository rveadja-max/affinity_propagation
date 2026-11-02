#!/usr/bin/env python3
"""Génère les figures de la fiche de synthèse Affinity Propagation.

Ces figures illustrent le fonctionnement d'AP et l'effet de ses deux paramètres
(préférence, amortissement) à partir de résultats RÉELS obtenus en exécutant AP
(scikit-learn) sur le jeu Iris standardisé. Elles sont régénérables avec :

    python3 fiche/make_figures.py          # depuis la racine du dépôt

Graine fixée (2026) pour la reproductibilité.
"""

from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
from sklearn.cluster import AffinityPropagation
from sklearn.datasets import load_iris
from sklearn.preprocessing import StandardScaler

GRAINE = 2026
OUT = Path(__file__).resolve().parent          # écriture dans fiche/
COULEURS = ["#4C72B0", "#55A868", "#C44E52", "#8172B2", "#937860",
            "#DA8BC3", "#8C8C8C", "#CCB974", "#64B5CD", "#D65F5F"]


def _donnees():
    """Charge Iris et renvoie les 2 variables les plus discriminantes, standardisées."""
    iris = load_iris()
    X = iris.data[:, [2, 3]]                   # longueur et largeur du pétale
    return StandardScaler().fit_transform(X), iris.target


def fig_principe():
    """Schéma en 3 étapes : données -> messages -> exemplaires et clusters."""
    X, _ = _donnees()
    rng = np.random.default_rng(GRAINE)
    idx = rng.choice(len(X), size=40, replace=False)
    pts = X[idx]
    pref = np.quantile(-(np.sum((pts[:, None] - pts[None, :]) ** 2, -1)), 0.6)
    ap = AffinityPropagation(preference=pref, damping=0.9,
                             random_state=GRAINE).fit(pts)
    lab = ap.labels_
    exe = ap.cluster_centers_indices_

    fig, axes = plt.subplots(1, 3, figsize=(9, 3))

    # Étape 1 — données brutes, toutes candidates
    axes[0].scatter(pts[:, 0], pts[:, 1], s=22, c=COULEURS[0], edgecolors="white",
                    linewidths=0.4)
    axes[0].set_title("1. Données de départ", fontsize=11, fontweight="bold")

    # Étape 2 — messages responsabilité / disponibilité
    ax = axes[1]
    ax.scatter(pts[:, 0], pts[:, 1], s=22, c=COULEURS[0], edgecolors="white",
               linewidths=0.4, zorder=3)
    ex = pts[exe]
    for e in ex:
        proches = np.argsort(np.sum((pts - e) ** 2, axis=1))[1:5]
        for p in proches:
            ax.annotate("", xy=e, xytext=pts[p],
                        arrowprops=dict(arrowstyle="->", color="#8E7CC3",
                                        lw=1.0, alpha=0.7))
    ax.scatter(ex[:, 0], ex[:, 1], s=120, facecolors="none", edgecolors="#C44E52",
               linewidths=1.8, zorder=4)
    ax.set_title("2. Échange de messages", fontsize=11, fontweight="bold")

    # Étape 3 — clusters et exemplaires réels
    ax = axes[2]
    for c, k in enumerate(np.unique(lab)):
        ax.scatter(pts[lab == k, 0], pts[lab == k, 1], s=24, c=COULEURS[c % 10],
                   edgecolors="white", linewidths=0.4)
    ax.scatter(ex[:, 0], ex[:, 1], marker="*", s=240, c="gold",
               edgecolors="black", linewidths=0.8, zorder=5, label="exemplaire (réel)")
    ax.set_title("3. Exemplaires et clusters", fontsize=11, fontweight="bold")
    ax.legend(loc="best", fontsize=7, frameon=False)

    for ax in axes:
        ax.set_xticks([]); ax.set_yticks([])
        for s in ax.spines.values():
            s.set_visible(False)
    fig.tight_layout()
    fig.savefig(OUT / "ap_principe.png", dpi=200, bbox_inches="tight")
    plt.close(fig)


def _ap(X, q):
    """AP à préférence = quantile q des similarités (comme l'argument q d'apcluster)."""
    S = -np.sum((X[:, None] - X[None, :]) ** 2, axis=-1)
    pref = float(np.quantile(S[~np.eye(len(X), dtype=bool)], q))
    return AffinityPropagation(preference=pref, damping=0.9,
                               random_state=GRAINE).fit(X)


def fig_preference():
    """Effet de la préférence : peu / médiane / beaucoup de clusters."""
    X, _ = _donnees()
    quantiles = [(0.0, "min"), (0.5, "médiane"), (0.9, "haute")]
    fig, axes = plt.subplots(1, 3, figsize=(9, 3))
    for ax, (q, nom) in zip(axes, quantiles):
        ap = _ap(X, q)
        lab, exe = ap.labels_, ap.cluster_centers_indices_
        k = len(exe)
        for c, cl in enumerate(np.unique(lab)):
            ax.scatter(X[lab == cl, 0], X[lab == cl, 1], s=14,
                       c=COULEURS[c % 10], edgecolors="none")
        ax.scatter(X[exe, 0], X[exe, 1], marker="*", s=110, c="black")
        ax.set_title(f"préférence {nom}\n$q$ = {q}  →  {k} clusters", fontsize=10)
    _habillage(fig, axes, "ap_preference.png")


def fig_amortissement():
    """Effet de l'amortissement : itérations croissantes, même partition."""
    X, _ = _donnees()
    lams, iters, ks = [], [], []
    for lam in (0.5, 0.7, 0.9):
        ap = AffinityPropagation(preference=float(
            np.median(-np.sum((X[:, None] - X[None, :]) ** 2, axis=-1))),
            damping=lam, random_state=GRAINE).fit(X)
        lams.append(str(lam)); iters.append(ap.n_iter_)
        ks.append(len(ap.cluster_centers_indices_))
    fig, ax = plt.subplots(figsize=(4.6, 2.9))
    bars = ax.bar(lams, iters, color="#8E7CC3", width=0.55)
    for b, k in zip(bars, ks):
        ax.text(b.get_x() + b.get_width() / 2, b.get_height() + 2,
                f"{k} clusters", ha="center", fontsize=9)
    ax.set_xlabel("amortissement $\\lambda$")
    ax.set_ylabel("itérations avant convergence")
    ax.set_title("Même partition, convergence plus lente", fontsize=10)
    ax.spines[["top", "right"]].set_visible(False)
    fig.tight_layout()
    fig.savefig(OUT / "ap_amortissement.png", dpi=200, bbox_inches="tight")
    plt.close(fig)


def _habillage(fig, axes, nom):
    for ax in np.atleast_1d(axes):
        ax.set_xticks([]); ax.set_yticks([])
        for s in ax.spines.values():
            s.set_visible(False)
    fig.tight_layout()
    fig.savefig(OUT / nom, dpi=200, bbox_inches="tight")
    plt.close(fig)


if __name__ == "__main__":
    fig_principe()
    fig_preference()
    fig_amortissement()
    print("Figures écrites dans", OUT)
