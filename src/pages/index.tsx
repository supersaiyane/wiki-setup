import type {ReactNode} from 'react';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';
import Heading from '@theme/Heading';

import styles from './index.module.css';

interface AppInfo {
  name: string;
  description: string;
  path: string;
  emoji: string;
}

// ============================================================
// ADD YOUR APPS HERE — just add an entry and drop the folder
// under docs/<folder-name>/
// ============================================================
const apps: ReadonlyArray<AppInfo> = [
  {
    name: 'Sample App',
    description: 'Example wiki showing how the structure works. Use as a reference.',
    path: '/docs/sample-app/',
    emoji: '📦',
  },
];

function HeroSection(): ReactNode {
  const {siteConfig} = useDocusaurusContext();
  return (
    <header className={`hero hero--primary ${styles.heroBanner}`}>
      <div className="container">
        <Heading as="h1" className={styles.heroTitle}>
          {siteConfig.title}
        </Heading>
        <p className={styles.heroSubtitle}>{siteConfig.tagline}</p>
        <div className={styles.heroActions}>
          <a className="button button--secondary button--lg" href="#app-wikis">
            Browse Docs
          </a>
        </div>
      </div>
    </header>
  );
}

function AppCard({name, description, path, emoji}: AppInfo): ReactNode {
  return (
    <Link to={path} className="app-card">
      <div style={{fontSize: '2rem', marginBottom: '0.75rem'}}>{emoji}</div>
      <Heading as="h3">{name}</Heading>
      <p>{description}</p>
    </Link>
  );
}

function AppsSection(): ReactNode {
  return (
    <section id="app-wikis" className={styles.appsSection}>
      <div className="container">
        <Heading as="h2" className={styles.sectionTitle}>
          App Wikis
        </Heading>
        <p className={styles.sectionSubtitle}>
          Select an app to read its documentation
        </p>
        <div className="apps-grid">
          {apps.map((app) => (
            <AppCard key={app.name} {...app} />
          ))}
        </div>
      </div>
    </section>
  );
}

export default function Home(): ReactNode {
  const {siteConfig} = useDocusaurusContext();
  return (
    <Layout title={siteConfig.title} description={siteConfig.tagline}>
      <HeroSection />
      <main>
        <AppsSection />
      </main>
    </Layout>
  );
}
