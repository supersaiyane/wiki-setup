import React from 'react';

interface Props {
  readonly onReload: () => void;
}

export default function PwaReloadPopup({onReload}: Props): JSX.Element {
  return (
    <div
      style={{
        position: 'fixed',
        bottom: '1.5rem',
        right: '1.5rem',
        padding: '1rem 1.5rem',
        borderRadius: '12px',
        background: '#1e293b',
        color: '#e2e8f0',
        boxShadow: '0 8px 32px rgba(0, 0, 0, 0.3)',
        zIndex: 1000,
        display: 'flex',
        alignItems: 'center',
        gap: '1rem',
        fontSize: '0.9rem',
        border: '1px solid rgba(99, 102, 241, 0.3)',
      }}>
      <span>New version available</span>
      <button
        type="button"
        onClick={onReload}
        style={{
          background: '#6366f1',
          color: 'white',
          border: 'none',
          borderRadius: '8px',
          padding: '0.4rem 1rem',
          cursor: 'pointer',
          fontWeight: 600,
          fontSize: '0.85rem',
        }}>
        Refresh
      </button>
    </div>
  );
}
