---
to: <%= rootDirectory %>/components/Link.tsx
force: true
---
'use client';

import * as React from 'react';
import NextLink from 'next/link';
import { styled } from '@mui/material/styles';
import MuiLink, { LinkProps as MuiLinkProps } from '@mui/material/Link';
import { usePathname } from 'next/navigation';
import clsx from 'clsx';

// Add support for the sx prop for consistency with the other branches.
const Anchor = styled('a')({});

export type LinkProps = {
  activeClassName?: string;
  as?: string;
  href: string | { pathname: string; query?: Record<string, string> };
  linkAs?: string;
  noLinkStyle?: boolean;
} & Omit<React.AnchorHTMLAttributes<HTMLAnchorElement>, 'href'> &
  Omit<MuiLinkProps, 'href'>;

// A styled version of the Next.js Link component compatible with App Router
const Link = React.forwardRef<HTMLAnchorElement, LinkProps>(function Link(props, ref) {
  const {
    activeClassName = 'active',
    as,
    className: classNameProps,
    href,
    linkAs: linkAsProp,
    locale,
    noLinkStyle,
    prefetch,
    replace,
    role,
    scroll,
    shallow,
    ...other
  } = props;

  const pathname = usePathname();
  const hrefString = typeof href === 'string' ? href : href.pathname;
  const className = clsx(classNameProps, {
    [activeClassName]: pathname === hrefString && activeClassName,
  });

  const isExternal =
    typeof href === 'string' && (href.indexOf('http') === 0 || href.indexOf('mailto:') === 0);

  if (isExternal) {
    if (noLinkStyle) {
      return <Anchor className={className} href={hrefString} ref={ref} {...other} />;
    }

    return <MuiLink className={className} href={hrefString} ref={ref} {...other} />;
  }

  const linkAs = linkAsProp || as;

  if (noLinkStyle) {
    return (
      <NextLink
        href={href}
        as={linkAs}
        replace={replace}
        scroll={scroll}
        prefetch={prefetch as any}
        locale={locale}
        {...other}
        ref={ref}
        className={className}
      />
    );
  }

  return (
    <MuiLink
      component={NextLink}
      href={href}
      as={linkAs}
      replace={replace}
      scroll={scroll}
      prefetch={prefetch as any}
      locale={locale}
      className={className}
      ref={ref}
      {...other}
    />
  );
});

export default Link;